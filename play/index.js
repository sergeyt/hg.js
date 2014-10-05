// export local hg for manual tests
path = require('path')
dir = path.join(__dirname, '..')
module.exports = require('../index')(dir)
