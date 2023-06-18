# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "react", to: "https://ga.jspm.io/npm:react@18.2.0/index.js"
pin "react-dom", to: "https://ga.jspm.io/npm:react-dom@18.2.0/index.js"
pin "scheduler", to: "https://ga.jspm.io/npm:scheduler@0.23.0/index.js"
pin "popper", to: 'popper.js', preload: true
pin "bootstrap", to: 'bootstrap.min.js', preload: true