output "project_id" {
  description = "Firebase project ID"
  value       = google_firebase_project.this.project
}

output "android_app_ids" {
  description = "Map of Android app keys to their Firebase app IDs"
  value       = { for k, v in google_firebase_android_app.apps : k => v.app_id }
}

output "ios_app_ids" {
  description = "Map of iOS app keys to their Firebase app IDs"
  value       = { for k, v in google_firebase_apple_app.apps : k => v.app_id }
}

output "web_app_ids" {
  description = "Map of web app keys to their Firebase app IDs"
  value       = { for k, v in google_firebase_web_app.apps : k => v.app_id }
}

output "firestore_database_name" {
  description = "Firestore database name"
  value       = length(google_firestore_database.default) > 0 ? google_firestore_database.default[0].name : ""
}
