const sha1 = require('sha1');
const axios = require('axios');
const constants = require('../../constants.json');

class BitcoinCashPaymentVerifier {

	constructor(orderRepository, debugLogger) {
		this.orderRepository = orderRepository;
		this.debugLogger = debugLogger;
	}

	GetVerificationHash(verificationData) {
		return sha1(verificationData.BCHAddress);
	}

	async VerifyPayment(orderID, verificationData) {
		let order = this.orderRepository.GetOrder(orderID);
		if (!order) {
			throw 'No order found with ID "'+orderID+'".';
		}

		let reasonForFailure = await this.verifyBitcoinCashPayment(order, verificationData.BCHAddress);
		if (reasonForFailure) {
			return {
				Verified: false,
				ReasonForFailure: reasonForFailure
			};
		}

		return {
			Verified: true,
			ReasonForFailure: null
		};
	}

	async verifyBitcoinCashPayment(order, BCHAddress) {
		let result = await axios.get('https://rest.bitcoin.com/v2/address/details/'+BCHAddress);

		if ((order.Price - result.totalReceived) > constants.MAX_BCH_PAYMENT_AMOUNT_DISCREPANCY) {
			return 'Received amount of BCH was '+result.totalReceived+', but the quoted price was '+order.Price+'.'
		}

		return null;
	}

}

module.exports = BitcoinCashPaymentVerifier;
