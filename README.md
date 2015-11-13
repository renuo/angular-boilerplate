# sample Portal

Sample Portal

# Domains

Live: http://www.sample.ch

## Prerequisites

This application requires node, for managing we use a [node version manager](https://github.com/creationix/nvm). 

## Setup Project

```
git clone git@github.com:renuo/sample-portal.git
cd sample-portal
npm install
tsd install
echo '127.0.0.1 sample-portal.dev' | sudo tee -a /etc/hosts # for a Consistent Browser History
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
