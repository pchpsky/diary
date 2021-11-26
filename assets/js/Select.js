export default {
  mounted() {
    this.el.addEventListener('mousedown', e => {
      e.preventDefault();
    })

    this.el.addEventListener('selected', e => {
      this.el.value = e.detail
    })
  }
}
