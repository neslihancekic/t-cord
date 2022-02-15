const jwt = require('jsonwebtoken')
const mongoose = require('mongoose')
const User = require('../../models/user')

const customerOneId = new mongoose.Types.ObjectId()
const customerOne = {
    _id: customerOneId,
    firstName: 'Test',
    lastName: 'Customer',
    username: 'test1',
    email: 'test@gmail.com',
    password: 'Aa123456',
    token: jwt.sign({ _id: customerOneId }, process.env.JWT_SECRET)
}

const customerTwoId = new mongoose.Types.ObjectId()
const customerTwo = {
    _id: customerTwoId,
    firstName: 'Test2',
    lastName: 'Customer2',
    username: 'test2',
    email: 'test2@gmail.com',
    password: 'Aa123456',
    token: jwt.sign({ _id: customerTwoId }, process.env.JWT_SECRET)
}

var customerThree = {
    _id: undefined,
    firstName: 'Test3',
    username: 'test3',
    lastName: 'Customer3',
    email: 'test3@gmail.com',
    password: 'Aa123456',
    token: undefined
}

const setupDatabaseUser = async () => {
    await User.deleteMany()
    await new User(customerOne).save()
    await new User(customerTwo).save()
}

module.exports = {
    customerOne,
    customerTwo,
    customerThree,
    setupDatabaseUser
}