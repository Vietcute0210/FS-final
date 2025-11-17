package com.group10.furniture_store.controller.admin;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.group10.furniture_store.domain.Product;
import com.group10.furniture_store.domain.ProductMedia;
import com.group10.furniture_store.domain.ProductMediaType;
import com.group10.furniture_store.domain.Warehouse;
import com.group10.furniture_store.service.ProductService;
import com.group10.furniture_store.service.UploadService;
import com.group10.furniture_store.service.WarehouseService;

import jakarta.validation.Valid;

@Controller
public class ProductController {
    private final UploadService uploadService;
    private final ProductService productService;
    private final WarehouseService warehouseService;
    private static final Set<String> VIDEO_EXTENSIONS = Set.of("mp4", "mov", "webm", "avi", "mkv", "ogg");

    public ProductController(UploadService uploadService, ProductService productService,
            WarehouseService warehouseService) {
        this.uploadService = uploadService;
        this.productService = productService;
        this.warehouseService = warehouseService;
    }

    @GetMapping("/admin/product")
    public String getProduct(Model model,
            @RequestParam("page") Optional<String> pageOptional) {
        int page = 1;
        try {
            if (pageOptional.isPresent()) {
                page = Integer.parseInt(pageOptional.get());
            }
        } catch (Exception ex) {
        }
        Pageable pageable = PageRequest.of(page - 1, 4);
        Page<Product> products = this.productService.getAllProducts(pageable);
        List<Product> listProducts = products.getContent();

        model.addAttribute("products", listProducts);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", products.getTotalPages());
        return "admin/product/show";
    }

    @GetMapping("/admin/product/create")
    public String getCreateProductPage(Model model) {
        model.addAttribute("newProduct", new Product());
        return "admin/product/create";
    }

    @PostMapping("/admin/product/create")
    public String handleCreateProduct(
            @ModelAttribute("newProduct") @Valid Product product,
            BindingResult newProductBindingResult,
            @RequestParam(value = "mediaFiles", required = false) MultipartFile[] mediaFiles) {
        if (newProductBindingResult.hasErrors()) {
            return "admin/product/create";
        }
        // upload image
        List<ProductMedia> medias = this.buildMediaList(product, mediaFiles);
        this.productService.handleSaveProduct(product);
        return "redirect:/admin/product";
    }

    private List<ProductMedia> buildMediaList(Product product, MultipartFile[] mediaFiles) {
        List<ProductMedia> medias = new ArrayList<>();
        if (mediaFiles == null) {
            return medias;
        }
        int position = 0;
        for (MultipartFile file : mediaFiles) {
            if (file == null || file.isEmpty()) {
                continue;
            }
            if (medias.size() >= 5) {
                break;
            }
            String savedName = this.uploadService.handleSaveUploadFile(file, "product");
            if (savedName == null || savedName.isEmpty()) {
                continue;
            }
            ProductMedia media = new ProductMedia();
            media.setFileName(savedName);
            media.setMediaType(this.detectMediaType(file.getOriginalFilename()));
            media.setPosition(position++);
            medias.add(media);
        }
        return medias;
    }

    private ProductMediaType detectMediaType(String originalFilename) {
        if (originalFilename == null) {
            return ProductMediaType.IMAGE;
        }
        int dotIndex = originalFilename.lastIndexOf('.');
        if (dotIndex == -1) {
            return ProductMediaType.IMAGE;
        }
        String extension = originalFilename.substring(dotIndex + 1).toLowerCase();
        return VIDEO_EXTENSIONS.contains(extension) ? ProductMediaType.VIDEO : ProductMediaType.IMAGE;
    }

    @GetMapping("/admin/product/{id}")
    public String getProductDetailPage(@PathVariable long id, Model model) {
        Product product = this.productService.getProductById(id);
        // Lấy warehouse để hiển thị quantity
        if (product != null) {
            Warehouse warehouse = warehouseService.getWarehouseByProductId(product.getId());
            if (warehouse != null) {
                product.setWarehouse(warehouse);
            }
        }
        model.addAttribute("product", product);
        return "admin/product/detail";
    }

    @GetMapping("/admin/product/update/{id}")
    public String getUpdateProductPage(@PathVariable long id, Model model) {
        Product currentProduct = this.productService.getProductById(id);
        // Lấy warehouse để hiển thị quantity
        if (currentProduct != null) {
            Warehouse warehouse = warehouseService.getWarehouseByProductId(currentProduct.getId());
            if (warehouse != null) {
                currentProduct.setWarehouse(warehouse);
            }
        }
        model.addAttribute("newProduct", currentProduct);
        return "admin/product/update";
    }

    @PostMapping("/admin/product/update/{id}")
    public String handleUpdateProduct(
            Model model,
            @ModelAttribute("newProduct") @Valid Product product,
            BindingResult bindingResult,
            @RequestParam(value = "productFile", required = false) MultipartFile file) {

        if (bindingResult.hasErrors()) {
            return "admin/product/update";
        }

        Product currentProduct = this.productService.getProductById(product.getId());
        if (currentProduct != null) {
            // Lấy từ db warehouse để đồng bộ quantity
            Warehouse warehouse = warehouseService.getWarehouseByProductId(currentProduct.getId());
            if (warehouse != null) {
                currentProduct.setWarehouse(warehouse);
            }

            // chỉ cập nhật ảnh khi có file mới đẩy lên
            if (file != null && !file.isEmpty()) {
                String image = this.uploadService.handleSaveUploadFile(file, "product");
                currentProduct.setImage(image);
            }
            currentProduct.setName(product.getName());
            currentProduct.setPrice(product.getPrice());
            // setQuantity sẽ tự động cập nhật vào warehouse
            currentProduct.setQuantity(product.getQuantity());
            currentProduct.setDetailDesc(product.getDetailDesc());
            currentProduct.setShortDesc(product.getShortDesc());
            currentProduct.setFactory(product.getFactory());
            currentProduct.setTarget(product.getTarget());
            currentProduct.setSold(product.getSold());

            this.productService.handleSaveProduct(currentProduct);
        }
        return "redirect:/admin/product";
    }

    @GetMapping("/admin/product/delete/{id}")
    public String deleteProductPage(Model model, @PathVariable Long id) {
        model.addAttribute("newProduct", new Product());
        model.addAttribute("id", id);
        return "admin/product/delete";
    }

    @PostMapping("/admin/product/delete/{id}")
    public String deleteProduct(Model model, @ModelAttribute("newProduct") Product product) {
        this.productService.handleDeleteProduct(product.getId());
        return "redirect:/admin/product";
    }

}
