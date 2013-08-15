require! {
	ObjectPool: '../build/object-pool'
}



class Foo
	(@bar, @baz) ->

	get: -> @bar

onAcquire = (@bar, @baz) !->

onRelease = !->
	delete @bar
	delete @baz



describe "new ObjectPool(ctor, options)" (...) !->
	it "set own ctor property to ctor" !->
		op = new ObjectPool Foo
		op.ctor.should.be.equal Foo

	it "default options are null for callbacks and js max int value for length" !->
		op = new ObjectPool Foo

		op.should.have.ownProperty 'onAcquire' null
		op.should.have.ownProperty 'onRelease' null
		op.length.should.equal Number.MAX_VALUE

	it "options can be overrided" !->
		onAcquire = -> 'onAcquire'
		onRelease = -> 'onRelease'
		length = 20

		op = new ObjectPool Foo, { onAcquire, onRelease, length }

		op.should.have.ownProperty 'onAcquire' onAcquire
		op.should.have.ownProperty 'onRelease' onRelease
		op.length.should.equal length



	describe ".acquire(...args)" (...) !->
		it "should return an instance of ctor" !->
			op = new ObjectPool Foo
			op.acquire!should.be.an.instanceOf Foo

		it "should create new instance if pool is empty" !->
			op = new ObjectPool Foo
			op.pool.should.be.empty

			op.release op.acquire!

			op.pool.length.should.be.equal 1

		it "should use pool defined instances" !->
			op = new ObjectPool Foo
			op.pool.should.be.empty

			a = op.acquire!
			b = op.acquire!

			op.release a
			op.release b

			op.pool.length.should.be.equal 2

			c = op.acquire!

			op.pool.length.should.be.equal 1

		it "should apply onAcquire function on acquired instance with custom args" !->
			op = new ObjectPool Foo, { onAcquire }
			instance = op.acquire 'bar value' 'baz value'

			instance.should.have.ownProperty 'bar' 'bar value'
			instance.should.have.ownProperty 'baz' 'baz value'



	describe ".release(instance, ...args)" (...) !->
		it "should release an instance" !->
			op = new ObjectPool Foo

			op.pool.should.be.empty
			a = op.acquire!
			op.pool.should.be.empty
			op.release a
			op.pool.length.should.be.equal 1

		it "should apply onRelease function on release instance with custom args" !->
			op = new ObjectPool Foo, { onAcquire, onRelease }
			instance = op.acquire 'bar value' 'baz value'
			op.release instance

			instance.should.not.have.ownProperty 'bar'
			instance.should.not.have.ownProperty 'baz'



	describe ".length" (...) !->
		it "should return defined length" !->
			op = new ObjectPool Foo
			op.length.should.be.equal Number.MAX_VALUE

			op = new ObjectPool Foo, { length: 10 }
			op.length.should.be.equal 10



	describe ".length = newValue" (...) !->
		it "should set length" !->
			op = new ObjectPool Foo
			op.length = 15
			op.length.should.be.equal 15
		


	describe ".clear()" (...) !->
		it "clear the pool container" !->
			op = new ObjectPool Foo
			op.release op.acquire!

			op.pool.should.be.not.empty

			op.clear!

			op.pool.should.be.empty