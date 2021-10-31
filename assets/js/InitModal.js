export default {
  mounted() {
    const handleOpenCloseEvent = event => {
      if (event.detail.open === false) {
        this.el.removeEventListener("modal-change", handleOpenCloseEvent)

        setTimeout(() => {
          // This timeout gives time for the animation to complete
          this.pushEventTo(event.detail.id, "modal:close", {})
        }, 300);
      }
    }

    // This listens to modal event from AlpineJs
    this.el.addEventListener("modal-change", handleOpenCloseEvent)

    // This is the open/close events that come from the LiveView
    this.handleEvent('modal:close', data => {
      const event = new CustomEvent('close-now')
      this.el.dispatchEvent(event)
    })

    this.handleEvent('modal:open', data => {
      const event = new CustomEvent('open-now')
      this.el.dispatchEvent(event)
    })
  }
}
