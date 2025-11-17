class AdminProductMediaManager {
  constructor({ rootSelector, addBtnSelector, maxSlots = 5 }) {
    this.root = document.querySelector(rootSelector);
    if (!this.root) {
      return;
    }
    this.addButton = this.root.querySelector(addBtnSelector);
    this.rowsContainer = this.root.querySelector(".media-manager-list");
    this.emptyMessage = this.root.querySelector(".media-manager-empty");
    this.limitNotice = this.root.querySelector(".media-manager-limit");
    this.maxSlots = maxSlots;
    this.accept = ".png,.jpg,.jpeg,.webp,.gif,.mp4,.webm,.mov,.avi,.mkv,.ogg";
    this.nextIndex = 1;

    if (this.addButton) {
      this.addButton.addEventListener("click", () => this.createSlot());
    }
    this.createSlot();
  }

  get slotCount() {
    return this.rowsContainer ? this.rowsContainer.children.length : 0;
  }

  createSlot(initialData = null) {
    if (this.slotCount >= this.maxSlots) {
      return;
    }
    const row = document.createElement("div");
    row.className = "media-row";
    row.dataset.slotId = this.nextIndex;

    const idColumn = document.createElement("div");
    idColumn.className = "media-row__id";
    idColumn.textContent = `${this.slotCount + 1}`;

    const previewColumn = document.createElement("div");
    previewColumn.className = "media-row__preview";
    const previewHint = document.createElement("span");
    previewHint.className = "media-row__empty";
    previewHint.textContent = "No file";
    previewColumn.appendChild(previewHint);

    const nameColumn = document.createElement("div");
    nameColumn.className = "media-row__name";
    nameColumn.textContent = "Choose a file";

    const actionsColumn = document.createElement("div");
    actionsColumn.className = "media-row__actions";

    const fileInput = document.createElement("input");
    fileInput.type = "file";
    fileInput.name = "mediaFiles";
    fileInput.accept = this.accept;
    fileInput.className = "d-none";
    fileInput.addEventListener("change", (event) =>
      this.handleFileSelection(
        row,
        event.target.files,
        previewColumn,
        nameColumn
      )
    );

    const changeButton = document.createElement("button");
    changeButton.type = "button";
    changeButton.className = "btn btn-outline-primary btn-sm";
    changeButton.textContent = "Change";
    changeButton.addEventListener("click", () => fileInput.click());

    const deleteButton = document.createElement("button");
    deleteButton.type = "button";
    deleteButton.className = "btn btn-outline-danger btn-sm";
    deleteButton.textContent = "Delete";
    deleteButton.addEventListener("click", () => this.removeSlot(row));

    actionsColumn.append(fileInput, changeButton, deleteButton);

    row.append(idColumn, previewColumn, nameColumn, actionsColumn);
    this.rowsContainer.appendChild(row);
    this.nextIndex += 1;
    this.refreshState();
  }

  handleFileSelection(row, files, previewColumn, nameColumn) {
    const file = files[0];
    if (!file) {
      return;
    }
    nameColumn.textContent = file.name;
    previewColumn.innerHTML = "";
    const isVideo = file.type.startsWith("video");
    const blobUrl = URL.createObjectURL(file);
    const previousUrl = row.dataset.previewUrl;
    if (previousUrl) {
      URL.revokeObjectURL(previousUrl);
    }
    row.dataset.previewUrl = blobUrl;
    const mediaElement = isVideo
      ? document.createElement("video")
      : document.createElement("img");
    mediaElement.src = blobUrl;
    if (isVideo) {
      mediaElement.muted = true;
      mediaElement.loop = true;
      mediaElement.autoplay = true;
      mediaElement.playsInline = true;
    }
    previewColumn.appendChild(mediaElement);
  }

  removeSlot(row) {
    const previewUrl = row.dataset.previewUrl;
    if (previewUrl) {
      URL.revokeObjectURL(previewUrl);
    }
    row.remove();
    this.refreshState();
  }

  refreshState() {
    [...this.rowsContainer.children].forEach((row, index) => {
      const idElement = row.querySelector(".media-row__id");
      if (idElement) {
        idElement.textContent = `${index + 1}`;
      }
    });
    if (this.emptyMessage) {
      this.emptyMessage.style.display = this.slotCount === 0 ? "block" : "none";
    }
    if (this.limitNotice) {
      this.limitNotice.style.display =
        this.slotCount >= this.maxSlots ? "block" : "none";
    }
    if (this.addButton) {
      this.addButton.disabled = this.slotCount >= this.maxSlots;
    }
  }
}

document.addEventListener("DOMContentLoaded", () => {
  new AdminProductMediaManager({
    rootSelector: "#mediaManager",
    addBtnSelector: "#mediaManagerAdd",
    maxSlots: 5,
  });
});
