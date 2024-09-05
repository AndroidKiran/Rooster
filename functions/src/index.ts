import {initializeApp} from "firebase-admin/app";
import {setGlobalOptions} from "firebase-functions/v2";

initializeApp();
setGlobalOptions({maxInstances: 10});

import {eventTriggers} from "./event_triggers";
Object.assign(exports, eventTriggers());
