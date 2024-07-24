data "spotify_search_track" "by_artist" {
  artist = "Sidhu Moose Wala"
}

resource "spotify_playlist" "playlist" {
  name        = "All time SMW Favourites"
  description = "This playlist was created by Terraform"
  public      = true

  tracks = [
    for idx in range(length(data.spotify_search_track.by_artist.tracks)) : data.spotify_search_track.by_artist.tracks[idx].id
  ]
}
