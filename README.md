# object-pool

	instance pool container

## Installation

```batch
$ component install wryk/object-pool
```

## Usage
	

```javasript
var ObjectPool = require('object-pool');

function myClass () {
	//do what you want with constructor and prototype
}

// Initialize a new custom ObjectPool
var myClassPool = new ObjectPool(myClass);

// Acquire a myClass instance from the pool
var myClassInstance = myClassPool.acquire();

// Release a myClass instance to the pool
myClassPool.release(myClassInstance);

// Get maximum number of instances
var maximumNumberOfInstances = myClassPool.length();

// Set maximum number of instances
myClassPool.length(150);

// Clear instance pool
myClassPool.clear();
```



## API


### new ObjectPool(ctor, [options])
	* ctor is a class constructor
	* options is an object that define base behavior
		* .length: maximum number of instances | Default : Number.MAX_VALUE
		* .onAcquire: called with current acquired instance context, construct-like function | Default: null
		* .onRelease: called with current released instance context, destruct-like function | Default: null

````javascript
// Stupid Person class
function Person (name) {
	this.name = name;
	this.friends = [];
}

Person.prototype.addFriend = function (person) {
	this.friends.push(person);
};

// initialize a personPool
var personPool = new ObjectPool(Person, {
	length: 20,
	onAcquire: function (name) { this.name = name; },
	onRelease: function () { this.friends = []; },
});
```

### .acquire(...args)
	apply .onAcquire function on current acquired instance from the pool with ...args as arguments and return it

```javascript
var joe = personPool.acquire('Joe');
var jane = personPool.acquire('Jane');

jane.name; // => 'Jane'

joe.addFriend(jane);
joe.friends.length; // => 1
```


### .release(instance, ...args)
	apply .onRelease function on current released instance from the pool with ...args as arguments and return it

```javascript
personPool.release(joe);
joe.friends.length; // => 0
```

### .length([newLength])
	* if newLength is falsy (basically undefined), return maximum number of instances
	* if newLength is defined, set maximum number of instances and return the object pool

### .clear()
	clear all pool entries

	

## Running tests
  First, make sure dependencies are installed:
```batch
$ npm install
```

  and run test:
```batch
$ make test
```

## License

  MIT