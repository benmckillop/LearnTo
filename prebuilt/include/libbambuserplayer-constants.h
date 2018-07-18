/*
 * libbambuser - Bambuser iOS library
 * Copyright 2016 Bambuser AB
 */

/** @file */

/**
 * \anchor BambuserPlayerState
 * Possible values of #BambuserPlayer.status.
 */
enum BambuserPlayerState {
	/// Playback is stopped
	kBambuserPlayerStateStopped = 0,
	/// Playback of the stream has been requested but not yet started
	kBambuserPlayerStateLoading = 1,
	/// Playback is in progress
	kBambuserPlayerStatePlaying = 2,
	/// Playback is paused
	kBambuserPlayerStatePaused = 3
};

/**
 * \anchor BroadcastState
 * Possible values for #BambuserPlayer.requiredBroadcastState
 */
enum BroadcastState {
	/// Any broadcast state
	kBambuserBroadcastStateAny = 0,
	/// Only live broadcasts
	kBambuserBroadcastStateLive = 1,
	/// Only archived broadcasts
	kBambuserBroadcastStateArchived = 2
};

/**
 * \anchor VideoScaleMode
 * Possible values for #BambuserPlayer.videoScaleMode
 */
enum VideoScaleMode {
	/// Specifies that the player should preserve the video's aspect ratio and fit the video within the view's bounds.
	VideoScaleAspectFit = 0,
	/// Specifies that the player should preserve the video's aspect ratio and fill the view's bounds.
	VideoScaleAspectFill = 1,
	/// Specifies that the video should be stretched to fill the view's bounds.
	VideoScaleToFill = 2
};
