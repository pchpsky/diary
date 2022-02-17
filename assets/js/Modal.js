export default {
  mounted() {
    this.modalId = this.el.id.replace(/^modal_/, "");

    this.onClose = event => {
      this.el.checked = false;
    }

    this.onOpen = event => {
      this.el.checked = true;
    }

    this.handleEvent(`modal:open:${this.modalId}`, this.onOpen)
    window.addEventListener(`modal:open:${this.modalId}`, this.onOpen)

    this.handleEvent(`modal:close:${this.modalId}`, this.onClose)
    window.addEventListener(`modal:close:${this.modalId}`, this.onClose)
  },

  destroyed() {
    window.removeEventListener(`modal:open:${this.modalId}`, this.onOpen)
    window.removeEventListener(`modal:close:${this.modalId}`, this.onClose)
  },
}
