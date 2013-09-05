module.exports = ObjectPool;

var slice = Array.prototype.slice;

function ObjectPool (ctor, options) {
	options = options || {};

	this.ctor = ctor;
	this.pool = [];
	
	this._length = options.length || Number.MAX_VALUE;
	this.onAcquire = options.onAcquire || null;
	this.onRelease = options.onRelease || null;
}

ObjectPool.prototype.acquire = function (/* acquire args */) {
	var instance;

	if (this.pool.length < 1) {
		instance = new this.ctor();
	} else {
		instance = this.pool.pop();
	}

	if (this.onAcquire) {
		this.onAcquire.apply(instance, arguments);
	}

	return instance;
};

ObjectPool.prototype.release = function (instance /*, release args */) {
	this.pool.push(instance);

	if (this.onRelease) {
		this.onRelease.apply(instance, slice.call(arguments, 1));
	}

	return this;
};

ObjectPool.prototype.clear = function () {
	this.pool = [];

	return this;
};

Object.defineProperty(ObjectPool.prototype, 'length', {
	configurable: true,
	get: function () {
		return this._length;
	},

	set: function (newLength) {
		this._length = newLength;

		if (newLength < this.pool.length) {
			this.pool.splice(newLength - 1);
		}

		return this;
	}
});