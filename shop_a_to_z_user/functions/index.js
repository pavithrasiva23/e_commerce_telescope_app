// Import component or piece of properties
const {onDocumentCreated} = require("firebase-functions/v2/firestore");

// Initialize the app
const {initializeApp} = require("firebase-admin/app");

const {setGlobalOptions} = require("firebase-functions/v2");

const {getMessaging} = require("firebase-admin/messaging");

const {logger} = require("firebase-functions/v2");

// Initialize the app
initializeApp();

// Returns the messaging object
const msg = getMessaging();

// Set global options for all functions in this file
setGlobalOptions({
  maxInstances: 10,
  region: "asia-south1",
});

// Maximum of 10 concurrent instances of our functions

// Creating a cloud function method
exports.sendOrderNotification = onDocumentCreated(
    "Orders/{orderId}",
    async (event) => {
      const topic = "order";
      const orderId = event.params.orderId;

      const payload = {
        notification: {
          title: "New Order Received",
          body:
            `You have received a new order with ID: ${orderId}`,
        },
        data: {
          // What kind of notification admin receives
          key: "new_order",
          value: orderId,
        },
        topic: topic,
      };

      await msg.send(payload)
          .then((response) => {
            // Can view logs in Firebase console
            logger.log(
                `Notification sent for new order ` +
                `with ID: ${orderId}`,
            );
          })
          .catch((error) => {
            logger.error(
                `Error sending notification ` +
                `for order with ID: ${orderId}`,
                error,
            );
          });
    },
);
