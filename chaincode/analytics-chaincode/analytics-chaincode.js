//clod16 chaincode


const shim = require('fabric-shim');
const datatransform = require("./utils/datatransform");
var logger = shim.newLogger('testChaincode');

logger.level = 'debug';

var Chaincode = class {


    async Init(stub) {
        logger.debug("________Init________");
        return shim.success(Buffer.from('Init - OK!'));

    }

    async Invoke(stub) {

        logger.info('________Invoke________')
        let ret = stub.getFunctionAndParameters();
        let fcn = ret.fcn;
        let args = ret.params;

        logger.info('do this fuction:' + fcn);
        logger.info(' List of args: ' + args);

        //list of methods

        if (fcn === 'getData') {
            return this.getData(stub, args);
        }

        if (fcn === 'putData') {
            return this.putData(stub, args);
        }

        logger.error('Error...probably wrong name of fuction!!!' + fcn);
        return shim.error('Error...probably wrong name of fuction!!!' + fcn);

    }



    async getData(stub, args) {
        logger.debug("________getData________");
        let stringGetbytes = null;
        if (args.length != 1) {
            return shim.error("Number of argument is wrong, expected one!!");
        }
        try {
            stringGetbytes = await stub.getState(args[0]);
            if (!stringGetbytes) {
                return shim.error(' Data with key' + args[0] + ' not found!!!');
            }
            const stringGet = datatransform.Transform.bufferToString(Buffer.from(stringGetbytes));
            logger.debug('getData extract: ' + stringGetbytes);
            return shim.success(Buffer.from(stringGet));
        } catch (e) {
            logger.info('getData - ERROR CATCH: ' + e);
            return shim.error('getData - Failed to get state with key: ' + key);

        }
    }

    async putData(stub, args) {
        logger.debug("________putData________");
        let data = null;
        if (args.length == 2) {
            try {
                await stub.putState(args[0], Buffer.from(args[1]));
                logger.debug('Data payload:' + args[1]);
                logger.debug('putData - Store successfull!!');
                return shim.success(Buffer.from('putData - Store successfull!!!'));
            } catch (e) {
                logger.info('putData - ERROR CATCH (putState): ' + e);
                return shim.error(e);

            }
        } else {
            return shim.error("Argument wrong, aspected exactly two argument!!" + args);
        }
    }
};

shim.start(new Chaincode());