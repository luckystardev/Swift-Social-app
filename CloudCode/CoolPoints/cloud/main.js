
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:

var Image = require("parse-image");

<html>
<body style="text-align:center;">
    <img border="0"
        src="http://files.parse.com/6ffa6b80-d0eb-401f-b663-22d4a16df004/bfed9ac4-058c-41fc-a0f1-fb6155572c12-ad77a082-453f-42f7-94ef-40c3f3e885e6.png"
        alt="Pulpit rock"
        width="300"
        height="150">
</body>
</html>

Parse.Cloud.define("mailgunSendMail", function(request, response) {
                   var Mailgun = require('mailgun');
                   Mailgun.initialize('photoshare.com', 'AppKey');
                   
                   Mailgun.sendEmail({
                                     to: "toTestuser@mail.com",
                                     from: "fromTestUser@mail.com",
                                     subject: "Hello from Cloud Code!",
                                     text: "Using Parse and Mailgun is great!",
                                     html: '<html><body><img src="' + request.params.imageUrlKey + '"></body></html>'                                 }, {
                                     success: function(httpResponse) {
                                     console.log(httpResponse);
                                     response.success("Email sent!");
                                     },
                                     error: function(httpResponse) {
                                     console.error(httpResponse);
                                     response.error("Uh oh, something went wrong");
                                     }
                                     });
                   });

Parse.Cloud.beforeSave("_User", function(request, response) {
                       var user = request.object;
                       
                       if(!user.dirty("userPhoto")) {
                           response.success();
                           return;
                       }
                       if (!user.get("userPhoto")) {
                           response.error("Users must have a profile photo.");
                           return;
                       }
                       
                       Parse.Cloud.httpRequest({
                                               url: user.get("userPhoto").url()
                       }).then(function(response) {
                               var image = new Image();
                               return image.setData(response.buffer);
                       }).then(function(image) {
                               return image.scale({
                                           ratio: 0.25,
                                           success: function(image) {
                                           
                                           },
                                           error: function(error) {
                                           
                                           }
                              });
                       }).then(function(image) {
                               return image.data();
                       }).then(function(buffer) {
                               var base64 = buffer.toString("base64");
                               var resizedImg = new Parse.File("userPhoto", { base64: base64 });
                               return resizedImg.save();
                       }).then(function(resizedImg) {
                               user.set("userPhoto", resizedImg);
                       }).then(function(result) {
                               response.success();
                           }, function(error) {
                               response.error(error);
                       });
                       
});