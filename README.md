# Angular Boilerplate

Here we provide a boilerplate for angular projects.

## Prerequisites

* [nodejs](https://nodejs.org/docs/v5.0.0/api/)
* [nvm](https://github.com/creationix/nvm)
* [gulp v4](https://github.com/gulpjs/gulp)
* [jdk](http://www.oracle.com/technetwork/java/javase/downloads/index.html) (if you run selenium locally)

## Setup Project

```
git clone git@github.com:renuo/angular-boilerplate.git
cd sample-portal
npm install
tsd install
echo '127.0.0.1 angular-boilerplate.dev' | sudo tee -a /etc/hosts # for a Consistent Browser History
```

## Type Definitions

Install a new definition (e.g. jquery): 

```
tsd query jquery --action install --save
```

Reinstall definitions: 

```
tsd reinstall --save --overwrite
```

Update all definitions

```
tsd update --save --overwrite
```

## npm shrinkwrap

A consistent shrinkwrap tool. Execute it always after installing a package.


```
npm shrinkwrap --dev
```
