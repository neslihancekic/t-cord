const sgMail = require('@sendgrid/mail');
sgMail.setApiKey(process.env.SENDGRID_API_KEY);

function sendResetPasswordEmail(res,user) {
    const emailData = {
        to: user.email,
        from: "tcord.app@gmail.com",
        subject: `Password change request`,
        html: `
        <h1>Hi ${user.username} 🚀!</h1>
        <h4>Your password recovery code is:</h4>
        <h2>${user.resetPasswordToken}</h2>
        <h4>This code will be expired in five hours!</h4>
        <h4>If you did not request this, please ignore this email and your password will remain unchanged.</h4>`
    };

    sgMail.send(emailData, (error, result) => {
        if (error) return res.fail(error.message);

        res.respond('A reset email has been sent to ' + user.email + '.');
    });
}

function sendPasswordChangedEmail(res, user) {
    const emailData = {
        to: user.email, 
        from: "tcord.app@gmail.com",
        subject: `Your password has been changed`,
        html: `
        <h1>Hi ${user.username} 🚀!</h1>
        <h2>This is a confirmation that the password for your account ${user.email} has just been changed.</h2>`
    };

    sgMail.send(emailData, (error, result) => {
        if (error) return res.fail(error.message);

        res.respond( 'Your password has been updated.');
    });
}
exports.sendResetPasswordEmail = sendResetPasswordEmail;
exports.sendPasswordChangedEmail = sendPasswordChangedEmail;