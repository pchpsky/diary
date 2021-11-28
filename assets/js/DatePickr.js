import flatpickr from "flatpickr";

export default {
  mounted() {
    this.pickr = flatpickr(this.el, {
      wrap: true,
      altInput: true,
      altFormat: "D, j M Y",
      dateFormat: "Y-m-d",
    })
  },

  updated() {
    this.pickr.destroy()
    this.pickr = flatpickr(this.el, {
      wrap: true,
      altInput: true,
      altFormat: "D, j M Y",
      dateFormat: "Y-m-d",
    })
  },

  destroyed() {
    this.pickr.destroy()
  }
};
