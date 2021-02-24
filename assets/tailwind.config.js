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
      'th-green-2': 'var(--green-2)'
    },
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
