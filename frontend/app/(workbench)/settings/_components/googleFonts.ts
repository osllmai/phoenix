export const BUNDLED_FONTS = new Set<string>([
  'DM Sans', 'Inter', 'Lora', 'Merriweather', 'Playfair Display', 'OpenDyslexic',
]);

export const GOOGLE_FONT_NAMES: string[] = [
  'Roboto', 'Poppins', 'Montserrat', 'Nunito', 'Open Sans', 'Source Sans 3',
  'Raleway', 'Work Sans', 'Rubik', 'Karla', 'Manrope', 'Space Grotesk',
  'IBM Plex Sans', 'Figtree', 'Outfit', 'Sora', 'Lexend', 'Mulish',
  'Noto Sans', 'PT Sans', 'Quicksand', 'Cabin', 'Josefin Sans', 'Nunito Sans',
  'Roboto Condensed', 'Roboto Slab', 'Roboto Mono', 'Barlow', 'Heebo',
  'Fira Sans', 'Hind', 'Titillium Web', 'Libre Franklin', 'Mukta', 'PT Serif',
  'Oswald', 'Bebas Neue', 'Anton', 'Archivo', 'Archivo Black', 'Asap',
  'Assistant', 'Bitter', 'Cairo', 'Catamaran', 'Chakra Petch', 'Comfortaa',
  'Cormorant', 'Cormorant Garamond', 'Crimson Text', 'DM Mono', 'DM Serif Display',
  'DM Serif Text', 'Dosis', 'EB Garamond', 'Exo', 'Exo 2', 'Fraunces',
  'Frank Ruhl Libre', 'Gelasio', 'Geologica', 'Gloria Hallelujah', 'Hanken Grotesk',
  'IBM Plex Mono', 'IBM Plex Serif', 'Inconsolata', 'Instrument Sans', 'Jost',
  'JetBrains Mono', 'Kanit', 'Kumbh Sans', 'Lato', 'League Spartan', 'Libre Baskerville',
  'Lilita One', 'Maven Pro', 'Merriweather Sans', 'Mona Sans', 'Mononoki',
  'Mooli', 'Newsreader', 'Noto Sans Display', 'Noto Sans Mono', 'Noto Serif',
  'Onest', 'Overpass', 'Oxygen', 'Pacifico', 'Petrona', 'Plus Jakarta Sans',
  'Prompt', 'Public Sans', 'Questrial', 'Readex Pro', 'Red Hat Display',
  'Red Hat Text', 'Rethink Sans', 'Roboto Flex', 'Saira', 'Schibsted Grotesk',
  'Signika', 'Signika Negative', 'Source Code Pro', 'Source Serif 4', 'Spectral',
  'Spline Sans', 'Syne', 'Tajawal', 'Teko', 'Tinos', 'Ubuntu', 'Ubuntu Mono',
  'Unbounded', 'Urbanist', 'Varela Round', 'Vollkorn', 'Yantramanav', 'Zilla Slab',
  'Abel', 'Acme', 'Alata', 'Albert Sans', 'Aleo', 'Alegreya', 'Alegreya Sans',
  'Amatic SC', 'Amiri', 'Arimo', 'Arvo', 'Asap Condensed', 'Barlow Condensed',
  'Barlow Semi Condensed', 'Be Vietnam Pro', 'Besley', 'Bodoni Moda', 'Bree Serif',
  'Bricolage Grotesque', 'Caveat', 'Changa', 'Chivo', 'Concert One', 'Cousine',
  'Crete Round', 'Dancing Script', 'Domine', 'Eczar', 'El Messiri', 'Encode Sans',
  'Fjalla One', 'Glegoo', 'Gothic A1', 'Hind Madurai', 'Hind Siliguri',
  'Italiana', 'Jaldi', 'Julius Sans One', 'Khand', 'Lobster', 'Lobster Two',
  'Macondo', 'Marcellus', 'Martel', 'Mate', 'Merienda', 'Michroma', 'Mitr',
  'Montserrat Alternates', 'Mr Dafoe', 'Noticia Text', 'Noto Serif Display',
  'Old Standard TT', 'Orbitron', 'Padauk', 'Patua One', 'Permanent Marker',
  'Philosopher', 'Playfair', 'Pontano Sans', 'Prata', 'Proza Libre', 'Rajdhani',
  'Ramabhadra', 'Righteous', 'Rokkitt', 'Ropa Sans', 'Rozha One', 'Sacramento',
  'Sarabun', 'Satisfy', 'Sawarabi Mincho', 'Secular One', 'Shadows Into Light',
  'Shrikhand', 'Slabo 27px', 'Sniglet', 'Special Elite', 'Stardos Stencil',
  'Tenor Sans', 'Trirong', 'Trocchi', 'Yanone Kaffeesatz', 'Yeseva One', 'Zeyada',
];

const injected = new Set<string>();
const pending = new Map<string, Promise<void>>();

function googleHref(family: string): string {
  const name = family.trim().replace(/\s+/g, '+');
  return `https://fonts.googleapis.com/css2?family=${name}:wght@400;700&display=swap`;
}

export function isBundled(family: string): boolean {
  return BUNDLED_FONTS.has(family);
}

export function loadGoogleFont(family: string): Promise<void> {
  if (typeof document === 'undefined') return Promise.resolve();
  if (isBundled(family) || injected.has(family)) return Promise.resolve();

  const existing = pending.get(family);
  if (existing) return existing;

  const href = googleHref(family);
  const promise = new Promise<void>((resolve, reject) => {
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = href;
    link.dataset.googleFont = family;
    link.onload = () => {
      injected.add(family);
      pending.delete(family);
      resolve();
    };
    link.onerror = () => {
      link.remove();
      pending.delete(family);
      reject(new Error(`Failed to load font: ${family}`));
    };
    document.head.appendChild(link);
  });

  pending.set(family, promise);
  return promise;
}
