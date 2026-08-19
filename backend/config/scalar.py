"""Scalar API reference for the ninja API — first-party assets only.

Palette mirrors the Ember tokens in frontend/app/tokens.css; Theme.NONE stops
Scalar shipping a palette of its own, so custom_css below is the whole theme.
"""
from scalar_ninja import AgentConfig, ScalarConfig, ScalarViewer, Theme

EMBER_CSS = """
:root {
  --scalar-font: 'Mulish', -apple-system, system-ui, sans-serif;
  --scalar-font-code: 'Roboto Mono', 'SF Mono', Menlo, monospace;
  --scalar-radius: 6px;
  --scalar-radius-lg: 10px;
  --scalar-radius-xl: 14px;
}
.dark-mode {
  --scalar-color-1: #F5EFE8;
  --scalar-color-2: #CBBBA8;
  --scalar-color-3: #9C8B78;
  --scalar-color-accent: #FF8A3D;
  --scalar-background-1: #17120E;
  --scalar-background-2: #221A13;
  --scalar-background-3: #2B2018;
  --scalar-background-accent: #3A2415;
  --scalar-border-color: #3A2C20;
  --scalar-color-green: #6FB585;
  --scalar-color-red: #E5645A;
  --scalar-color-yellow: #E8C24A;
  --scalar-color-blue: #6E9CB5;
  --scalar-color-orange: #FF8A3D;
  --scalar-color-purple: #A98FC2;
  --scalar-button-1: #FF8A3D;
  --scalar-button-1-color: #1A130D;
  --scalar-button-1-hover: #FF9D5C;
}
.light-mode {
  --scalar-color-1: #2A2017;
  --scalar-color-2: #5C5142;
  --scalar-color-3: #897A65;
  --scalar-color-accent: #D9641A;
  --scalar-background-1: #FFFDF9;
  --scalar-background-2: #F7F1E8;
  --scalar-background-3: #F0E7D8;
  --scalar-background-accent: #FBE7D6;
  --scalar-border-color: #E3D7C3;
  --scalar-color-green: #4E9A6B;
  --scalar-color-red: #C15B52;
  --scalar-color-yellow: #C9911F;
  --scalar-color-blue: #5B8BA5;
  --scalar-color-orange: #D9641A;
  --scalar-color-purple: #8A6CA8;
  --scalar-button-1: #D9641A;
  --scalar-button-1-color: #FFFDF9;
  --scalar-button-1-hover: #C0530F;
}
.dark-mode .t-doc__sidebar, .light-mode .t-doc__sidebar {
  --scalar-sidebar-background-1: var(--scalar-background-2);
  --scalar-sidebar-border-color: var(--scalar-border-color);
  --scalar-sidebar-color-1: var(--scalar-color-1);
  --scalar-sidebar-color-2: var(--scalar-color-2);
  --scalar-sidebar-color-active: var(--scalar-color-accent);
  --scalar-sidebar-item-hover-background: var(--scalar-background-3);
  --scalar-sidebar-item-active-background: var(--scalar-background-accent);
  --scalar-sidebar-search-background: var(--scalar-background-3);
  --scalar-sidebar-search-border-color: var(--scalar-border-color);
}
"""

docs_viewer = ScalarViewer(
    ScalarConfig(
        title='Phoenix API',
        openapi_url='/api/v1/openapi.json',
        agent=AgentConfig(disabled=True),
        scalar_js_url='/scalar/standalone.js',
        scalar_favicon_url='/scalar/favicon.svg',
        theme=Theme.NONE,
        custom_css=EMBER_CSS,
        with_default_fonts=False,
        dark_mode=True,
        authentication={'preferredSecurityScheme': 'SessionTokenAuth'},
    )
)
