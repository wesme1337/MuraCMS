
const cache = {};

function importAll (r) {
    r.keys().forEach(key => cache[key] = r(key));
  }

importAll(require.context('./_modules', true, /\.js$/));

