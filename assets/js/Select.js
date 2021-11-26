export default {
  mounted() {
    this.el.addEventListener('mousedown', e => {
      e.stopPropagation();
      e.preventDefault();
      this.el.blur();
      window.focus();
    })

    this.el.addEventListener('selected', e => {
      this.el.value = e.detail
    })
  }
}
