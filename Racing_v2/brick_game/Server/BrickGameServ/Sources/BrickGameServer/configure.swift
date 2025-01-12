import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    try routes(app)
    let corsConfig = CORSMiddleware.Configuration(
//        allowedOrigin: .all,
        allowedOrigin: .any(["http://127.0.0.1:5500", "http://127.0.0.1:5501", "http://localhost:5500"]),
        allowedMethods: [.GET, .POST, .PUT, .DELETE],
        allowedHeaders: [.contentType, .authorization, .origin])
    
    app.middleware.use(CORSMiddleware(configuration: corsConfig))
//            app.http.server.configuration.port = 5500
}
