/// The curated phone bottom-bar destinations, in order, per the mobile mock
/// (Home · Chat · Models · Docs · More). Everything else is reached via the
/// More hub. Icons come from each feature's registered nav item; only labels
/// that differ from the registry are overridden here.
const phonePrimaryPaths = <String>['/home', '/', '/models', '/documents'];

const phoneNavLabels = <String, String>{'/models': 'Models'};
