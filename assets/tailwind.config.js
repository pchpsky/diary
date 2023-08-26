const colors = require('tailwindcss/colors')

module.exports = {
  mode: "jit",
  content: [
    './js/**/*.js',
    '../lib/*_web/**/*.*ex',
    '../lib/*_web.ex',
    '../lib/*_web/**/*_html.ex'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        'th-bgc-main': 'var(--bgc-main)',
        'th-text-primary': 'var(--text-primary)',
        'th-green-1': 'var(--green-1)',
        'th-green-2': 'var(--green-2)',
        'th-green-3': 'var(--green-3)',
        'th-grey-1': 'var(--grey-1)',
        'th-grey-2': 'var(--grey-2)'
      }
    },
  },
  plugins: [
    require('daisyui'),
    require('@tailwindcss/forms'),
  ],
}
