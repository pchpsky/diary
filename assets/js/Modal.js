export default {
  mounted() {
    this.modalId = this.el.id.replace(/^modal_/, "");

    this.onClose = event => {
      this.__liveSocket.execJS(this.el, this.el.dataset.jsHide)
      setTimeout(() => {
        this.el.classList.add("hidden");
      }, 300);
    }

    this.onOpen = event => {
      this.el.classList.remove("hidden");
      this.__liveSocket.execJS(this.el, this.el.dataset.jsShow)
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
