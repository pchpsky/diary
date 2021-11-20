import flatpickr from "flatpickr";

export default {
  mounted() {
    this.pickr = flatpickr(this.el, {
      wrap: true,
      // altInput: true,
      enableTime: true,
      noCalendar: true,
      dateFormat: "H:i",
      time_24hr: true
    })
  },

  destroyed() {
    this.pickr.destroy()
  }
};
