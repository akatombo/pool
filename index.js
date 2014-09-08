import ObjectProvider from './object-provider';
export default Pool;

var objectProvider = new ObjectProvider();

/**
 * @class Pool
 * @constructor
 * @param {Object} provider
 * @param {Number} [max=Number.MAX_VALUE]
**/
function Pool (provider, max) {
	/**
	 * @property _cache
	 * @private
	 * @type {Array}
	 * @default []
	**/
	this._cache = [];

	/**
	 * @property _cache
	 * @private
	 * @type {Object}
	 * @default new ObjectProvider()
	**/
	this._provider = provider || objectProvider;

	/**
	 * @property _max
	 * @private
	 * @type {Number}
	 * @default Number.MAX_VALUE
	**/
	this._max = typeof max === 'number' ? max : Number.MAX_VALUE;
}

/**
 * @property max
 * @type {Number}
 * @default Number.MAX_VALUE
 */
Object.defineProperty(Pool.prototype, 'max', {
	get: function () {
		return this._max;
	},
	set: function (value) {
		this._max = value;
		this._cache.splice(this._cache.length, this._cache.length - thix._max);
	}
});

/**
 * @property size
 * @type {Number}
 * @default 0
 */
Object.defineProperty(Pool.prototype, 'size', {
	get: function () {
		return this._cache.length;
	}
});

/**
 * @method acquire
 * @param {any} [argument]*
 * @return {Object}
**/
Pool.prototype.acquire = function () {
	return this._cache.length === 0 ?
		this._provider.acquire.apply(this._provider, arguments) :
		this._cache.pop();
};

/**
 * @method release
 * @param {Object} instance
 * @param {any} [argument]*
 * @return {Pool}
**/
Pool.prototype.release = function (instance) {
	if (this._cache.length !== this._max && !~this._cache.indexOf(instance)) {
		this._provider.release.apply(this._provider, arguments);
		this._cache.push(instance);
	}

	return this;
};

/**
 * @method clear
 * @return {Pool}
**/
Pool.prototype.clear = function () {
	this._cache.splice(0);

	return this;
};

/**
 * @method fill
 * @return {Pool}
**/
Pool.prototype.fill = function () {
	for (i = this._cache.length - 1, l = this._max; ++i < l;) {
		this._cache.push(this._provider.acquire.apply(this._provider, arguments));
	}

	return this;
};