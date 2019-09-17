const jQuery=require('jquery');
const cache = {};

function importAll (r) {
  r.keys().forEach(key => cache[key] = r(key));
}

importAll(require.context('./_jquery', true, /\.js$/));
