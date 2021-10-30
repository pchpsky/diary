import flatpickr from "flatpickr";

export default {
  mounted() {
    this.pickr = flatpickr(this.el, {
      wrap: true,
      enableTime: true,
      altInput: true,
      altFormat: "D, j M Y, H:i",
      dateFormat: "Z",
      time_24hr: true,
    })
  },

  destroyed() {
    this.pickr.destroy()
  }
};
