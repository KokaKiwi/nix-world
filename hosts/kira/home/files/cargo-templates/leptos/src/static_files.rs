use axum::response::{IntoResponse, Response};
use axum::{body::Body, extract::State, http};
use leptos::LeptosOptions;

pub async fn file_or_error_handler(
    State(leptos_options): State<LeptosOptions>,
    req: http::Request<Body>,
) -> Response {
    let root = leptos_options.site_root.as_str();
    let (parts, body) = req.into_parts();

    let mut static_parts = parts.clone();
    static_parts.headers.clear();
    if let Some(encodings) = parts.headers.get("Accept-Encoding") {
        static_parts
            .headers
            .insert("Accept-Encoding", encodings.clone());
    }

    let static_request = http::Request::from_parts(static_parts, Body::empty());
    let res = match get_static_file(root, static_request).await {
        Ok(res) => res,
        Err(err) => return err.into_response(),
    };

    if res.status().is_success() {
        res.into_response()
    } else {
        use {{crate_name}}::app::App;

        let handler = leptos_axum::render_app_to_stream(leptos_options, App);
        let req = http::Request::from_parts(parts, body);

        handler(req).await.into_response()
    }
}

async fn get_static_file(
    root: &str,
    req: http::Request<Body>,
) -> Result<http::Response<Body>, (http::StatusCode, String)> {
    use tower::ServiceExt;
    use tower_http::services::ServeDir;

    let service = ServeDir::new(root).precompressed_gzip().precompressed_br();
    match service.oneshot(req).await {
        Ok(res) => Ok(res.into_response()),
        Err(err) => Err((
            http::StatusCode::INTERNAL_SERVER_ERROR,
            format!("Error serving file: {err}"),
        )),
    }
}
