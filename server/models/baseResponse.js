class BaseResponse {
    constructor(data, isSuccess, errorMessage,errorCode) {
      this.data = data;
      this.isSuccess = isSuccess;
      this.errorMessage = errorMessage;
      this.errorCode = errorCode;
    }
  }