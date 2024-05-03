import {InitializeEventTriggers} from "./initialize_event_triggers";
import {IssueEventTriggers} from "./issue_event_triggers";


export const eventTriggerList: Array<InitializeEventTriggers> = [
  new IssueEventTriggers(),
];

export function eventTriggers(): object {
  const res: any = {};
  for (const v2 of eventTriggerList) {
    v2.initialize((params) => {
      res[params.name] = params.handler;
    });
  }
  return res;
}
