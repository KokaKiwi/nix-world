use fluent_templates::static_loader;
use leptos::*;
use leptos_meta::*;

static_loader! {
    static TRANSLATIONS = {
        locales: "./locales",
        fallback_language: "en",
    };
}

#[component]
pub fn App() -> impl IntoView {
    leptos_fluent::leptos_fluent! {
        locales: "./locales",
        translations: [TRANSLATIONS],
        #[cfg(debug_assertions)]
        check_translations: "./src/**/*.rs",
    };

    provide_meta_context();

    view! {
        <Stylesheet id="leptos" href="/pkg/{{project-name}}.css" />
        <Title text="{{project-name}}" />
    }
}
