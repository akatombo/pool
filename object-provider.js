export default ObjectProvider;

/**
 * @class ObjectProvider
 * @constructor
**/
function ObjectProvider () {}

/**
 * @method acquire
 * @return {Object}
**/
ObjectProvider.prototype.acquire = function () {
	return {};
};

/**
 * @method release
 * @param {Object} instance
**/
ObjectProvider.prototype.release = function (instance) {
	Object.keys(instance).forEach(function (key) {
		delete instance[key];
	});
};