import s from '../page.module.css';
import { EndpointsCard, McpCard, ModelRouting, StatusUsage } from './cards';
import { ApiKeys, LangChainCard, QuickStart } from './QuickStart';
import RequestLog from './RequestLog';

export default function SuccessView() {
  return (
    <div className={s.body}>
      <StatusUsage />
      <EndpointsCard />
      <McpCard />
      <ModelRouting />
      <RequestLog />
      <ApiKeys />
      <QuickStart />
      <LangChainCard />
    </div>
  );
}
