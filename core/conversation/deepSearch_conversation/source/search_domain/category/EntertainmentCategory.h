#ifndef ENTERTAINMENTCATEGORY_H
#define ENTERTAINMENTCATEGORY_H

enum class EntertainmentCategory {

    // ===== Media =====
    Movies,              // Movies and cinema
    TVSeries,            // TV series
    StreamingMedia,      // Streaming platforms like Netflix, Disney+, etc.
    Animation,           // Animation and cartoons
    Documentary,         // Documentary films

    // ===== Music =====
    Music,               // General music category
    Albums,              // Music albums
    Singles,             // Individual music tracks
    MusicVideos,         // Music videos
    Concerts,            // Live concerts and tours
    MusicGenres,         // Music genres and styles

    // ===== Gaming =====
    VideoGames,          // Video games on consoles and PC
    BoardGames,          // Physical board games
    MobileGames,         // Games on mobile platforms
    Esports,             // Competitive gaming and tournaments
    GameReviews,         // Reviews of games
    GameGuides,          // Game walkthroughs and guides
    GameEvents,          // Gaming events and conventions

    // ===== Celebrities & Public Figures =====
    Actors,              // Film actors
    Actresses,           // Film actresses
    Directors,           // Film and TV directors
    Producers,           // Producers in entertainment
    Musicians,           // Music artists and bands
    Singers,             // Vocal artists
    Athletes,            // Sports celebrities
    Influencers,         // Social media influencers
    PublicFigures,       // Other well-known public figures
    CelebrityNews,       // News about celebrities

    // ===== Events & Awards =====
    FilmFestivals,       // Film festivals
    AwardShows,          // Award ceremonies
    MusicAwards,         // Music award events
    GameAwards,          // Gaming award events
    EntertainmentEvents, // Other entertainment events

    // ===== Literature & Comics =====
    Books,               // Books in general
    Comics,              // Comic books
    GraphicNovels,       // Graphic novels
    Manga,               // Manga books
    LiteratureEvents,    // Book fairs, author events, literary festivals

    // ===== Pop Culture & Fandom =====
    PopCulture,          // Popular culture topics
    Fandoms,             // Fan communities
    Memes,               // Internet memes
    Trends,              // Current entertainment trends
    InternetCulture,     // Online culture

    // ===== Media Types & Formats =====
    Reviews,             // Reviews of media content
    Interviews,          // Interviews with personalities
    Trailers,            // Movie, game, or series trailers
    BehindTheScenes,     // BTS content and making-of materials

    Miscellaneous        // Other uncategorized entertainment content
};

#endif // ENTERTAINMENTCATEGORY_H
