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
      'th-primary': 'var(--primary)'
    },
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
