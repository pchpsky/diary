const colors = require('tailwindcss/colors')

module.exports = {
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex',
    './js/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    colors: {
      'th-bgc-main': 'var(--bgc-main)',
      'th-text-primary': 'var(--text-primary)',
      'th-green-1': 'var(--green-1)',
      'th-green-2': 'var(--green-2)',
      'th-insulin': 'var(--th-insulin)',
      black: colors.black,
      grey: colors.coolGray,
      blue: colors.blue,
      white: colors.white,
      red: colors.red,
      transparent: colors.transparent,
    },
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [
    // require('@tailwindcss/forms'),
  ],
}
