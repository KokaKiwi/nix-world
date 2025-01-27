import typography from '@tailwindcss/typography';
import daisyui from 'daisyui';
import catppuccin from '@catppuccin/daisyui';

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: {
    relative: true,
    files: ["*.html", "./src/**/*.rs"],
  },
  plugins: [
    typography(),
    daisyui,
  ],
  daisyui: {
    darkTheme: 'mocha',
    themes: [
      'light',
      catppuccin('mocha'),
    ],
  },
  theme: {
    extend: {},
  },
};
