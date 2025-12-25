#ifndef SPORTCATEGORY_H
#define SPORTCATEGORY_H

enum class SportCategory {

    // ===== General =====
    GeneralSports,         // General sports topics
    Fitness,               // General fitness and workouts
    Coaching,              // Sports coaching and training
    SportsAnalytics,       // Sports data analysis and statistics

    // ===== Team Sports =====
    Football,              // Football (soccer)
    Soccer,                // International term for football
    AmericanFootball,      // American football
    Basketball,            // Basketball
    Baseball,              // Baseball
    Volleyball,            // Volleyball
    Rugby,                 // Rugby
    Handball,              // Handball
    IceHockey,             // Ice hockey
    Cricket,               // Cricket
    WaterPolo,             // Water polo

    // ===== Individual Sports =====
    Tennis,                // Tennis
    TableTennis,           // Table tennis / Ping pong
    Badminton,             // Badminton
    Squash,                // Squash
    Golf,                  // Golf
    Athletics,             // Track and field
    Swimming,              // Swimming
    Gymnastics,            // Gymnastics
    Boxing,                // Boxing
    Wrestling,             // Wrestling
    Judo,                  // Judo
    Karate,                // Karate
    Taekwondo,             // Taekwondo
    MixedMartialArts,      // MMA - Mixed Martial Arts
    Weightlifting,         // Weightlifting
    Cycling,               // Cycling
    Triathlon,             // Triathlon
    Archery,               // Archery
    Shooting,              // Shooting sports

    // ===== Winter Sports =====
    Skiing,                // Skiing
    Snowboarding,          // Snowboarding
    IceSkating,            // Ice skating
    Curling,               // Curling
    Bobsleigh,             // Bobsleigh / Bobsled
    Luge,                  // Luge
    Biathlon,              // Biathlon (ski + shooting)

    // ===== Motorsports =====
    Formula1,              // Formula 1 racing
    MotoGP,                // MotoGP motorcycle racing
    Rally,                 // Rally racing
    NASCAR,                // NASCAR racing
    MotoCross,             // Motocross racing

    // ===== Extreme / Adventure Sports =====
    Climbing,              // General climbing
    RockClimbing,          // Rock climbing
    Mountaineering,        // Mountaineering / mountain expeditions
    Surfing,               // Surfing
    Skateboarding,         // Skateboarding
    Parkour,               // Parkour / freerunning
    Skydiving,             // Skydiving
    Paragliding,           // Paragliding

    // ===== eSports =====
    Esports,               // eSports in general
    MOBA,                  // Multiplayer Online Battle Arena (LoL, Dota2)
    FPS,                   // First-person shooter games (CS, Valorant)
    BattleRoyale,          // Battle royale games (Fortnite, PUBG)
    FightingGames,         // Fighting games (Tekken, Street Fighter)
    StrategyGames,         // Strategy games (Starcraft, Age of Empires)

    // ===== Events / Competitions =====
    Olympics,              // Olympic Games
    WorldChampionships,    // World championship events
    NationalLeagues,       // National leagues
    Tournaments,           // Sports tournaments
    Cups,                  // Cup competitions

    // ===== Athletes & Personalities =====
    Athletes,              // Individual athletes
    Coaches,               // Coaches and trainers
    Teams,                 // Teams

    // ===== Other / Misc =====
    Miscellaneous          // Any other sports topics not categorized above
};

#endif // SPORTCATEGORY_H
