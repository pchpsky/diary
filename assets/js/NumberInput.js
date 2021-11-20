import Cleave from 'cleave.js';

export default {
  mounted() {
    this.el.querySelectorAll('input').forEach(el => {
      new Cleave(el, {
        numeral: true,
        numeralIntegerScale: 2,
        numeralDecimalScale: 1
      })

      el.addEventListener('inc', _e => {
        const num = Math.round(Number(el.value))

        if (num < 99) {
          el.value = (num + 1).toFixed(1)
        }
      })
      el.addEventListener('dec', _e => {
        const num = Math.round(Number(el.value))

        if (num > 0) {
          el.value = (num - 1).toFixed(1)
        }
      })
    })
  }
}
