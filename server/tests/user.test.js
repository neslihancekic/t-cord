const request = require('supertest')
const app = require('../app')
const User = require('../models/user')
const mongoose = require('mongoose')
const { customerOne, customerTwo, customerThree, setupDatabaseUser } = require('./fixtures/userDb')

beforeEach(setupDatabaseUser)
jest.setTimeout(10000)

test('Must database connected', async () => {
    const response = mongoose.connection.readyState;
    // database connected?
    expect(response).toBe(1)
})

test('Should signup if email is not already taken', async () => {
    var response= await request(app)
        .post('/api/signup')
        .send({
            firstName: customerThree.firstName,
            lastName: customerThree.lastName,
            username: customerThree.username,
            email: customerThree.email,
            password: customerThree.password
        })
        .expect(201)
    expect(response.body).toMatchObject({
        user: {
            firstName: customerThree.firstName,
            lastName: customerThree.lastName,
            username: customerThree.username,
            email: customerThree.email
        }
    })
})


test('Should not signup if email is already taken', async () => {
    await request(app)
        .post('/api/signup')
        .send({
            firstName: customerOne.firstName,
            lastName: customerOne.lastName,
            username: customerOne.username,
            email: customerOne.email,
            password: customerOne.password
        })
        .expect(400)
})

test('Should login existing user', async () => {
    const response = await request(app)
        .post('/api/signin')
        .send({
            username: customerOne.username,
            password: customerOne.password
        })
        .expect(200)

    expect(response.body).toMatchObject({
        user: {
            firstName: customerOne.firstName,
            lastName: customerOne.lastName,
            username: customerOne.username,
            email: customerOne.email
        }
    })
})

test('Should not signin if non existing user provided', async () => {
    var response= await request(app)
        .post('/api/signin')
        .send({
            username: "nouser",
            password: "123123123qwe"
        })
        .expect(400)
    expect(response.body).toMatchObject({
        error:"User with that email does not exist. Please signup."
    })
})

test('Should not signin if password is wrong', async () => {
    var response=await request(app)
        .post('/api/signin')
        .send({
            username: customerOne.username,
            password: "123123123qwe"
        })
        .expect(401)
    expect(response.body).toMatchObject({
        error:"Email and password do not matched."
    })
})


test('Should user delete its account', async () => {
    var response = await request(app)
        .delete(`/api/user/${customerTwo._id}`)
        .set('Authorization', `Bearer ${customerTwo.token}`)
        .expect(200);
    expect(response.body).toMatchObject({
        message: "User deleted!"
    })
})

test('Should signout', async () => {
    var response = await request(app)
        .get('/api/signout')
        .expect(200);
    expect(response.body).toMatchObject({
        message: "Signout Success"
    })    
})

test('Should get user info', async () => {
    const response = await request(app)
        .get(`/api/user/${customerOne._id}`)
        .set('Authorization', `Bearer ${customerOne.token}`)
        .expect(200)
    expect(response.body).toMatchObject({
        firstName: customerOne.firstName,
        lastName: customerOne.lastName,
        username: customerOne.username,
        email: customerOne.email
    })
})

test('Should get user secret info', async () => {
    const response = await request(app)
        .get(`/api/secret/${customerOne._id}`)
        .set('Authorization', `Bearer ${customerOne.token}`)
        .expect(200)
})

test('Should not get user info if non existing user provided', async () => {
    const response = await request(app)
        .get(`/api/user/3213123`)
        .set('Authorization', `Bearer ${customerOne.token}`)
        .expect(400)

    expect(response.body).toMatchObject({
        error: "User not found!"
    })
})

test('Should not get user info if not authorized', async () => {
    await request(app)
        .get(`/api/user/${customerOne._id}`)
        .expect(401)
})

test('Should update user info', async () => {
    const response = await request(app)
        .put(`/api/user/${customerOne._id}`)
        .set('Authorization', `Bearer ${customerOne.token}`)
        .send({
            firstName: "yeni"
        })
        .expect(200)

    expect(response.body).toMatchObject({
        firstName: "yeni",
        lastName: customerOne.lastName,
        username: customerOne.username,
        email: customerOne.email
    })

    const user = await User.findById(customerOne._id)
    expect(user.firstName).toBe("yeni")
})

test('Should not update if other user', async () => {
    const response = await request(app)
        .put(`/api/user/${customerOne._id}`)
        .set('Authorization', `Bearer ${customerTwo.token}`)
        .send({
            firstName: "yeni"
        })
        .expect(403)

    expect(response.body).toMatchObject({
        error: "Access denied."
    })
    const user = await User.findById(customerOne._id)
    expect(user.firstName).not.toBe("yeni")
})

test('Should not update user info if not authorized', async () => {
    const response = await request(app)
        .put(`/api/user/${customerOne._id}`)
        .send({
            firstName: "yeni"
        })
        .expect(401)
})




afterAll(done => {
    mongoose.connection.close()
    done()
})