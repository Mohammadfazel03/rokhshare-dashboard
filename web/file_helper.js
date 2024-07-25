function getVideoThumbnail(file, callback) {
  const video = document.createElement('video');
  video.preload = 'metadata';
  video.src = URL.createObjectURL(file);

  video.onloadedmetadata = function() {
    video.currentTime = 1;
  };

  video.onerror = function() {
    console.error('Error loading video metadata.');
    URL.revokeObjectURL(video.src); // Revoke URL on error
    callback(null, null);
  };

  video.onseeked = function() {
    try {
      const canvas = document.createElement('canvas');
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;
      const context = canvas.getContext('2d');
      context.drawImage(video, 0, 0, canvas.width, canvas.height);
      const thumbnail = canvas.toDataURL('image/png');
      URL.revokeObjectURL(video.src); // Revoke URL after use
      callback(thumbnail, video.duration);
    } catch (error) {
      console.error('Error generating thumbnail:', error);
      URL.revokeObjectURL(video.src); // Revoke URL on error
      callback(null, null);
    }
  };
}

function readChunk(file, start, end, callback) {
  const reader = new FileReader();
  reader.onload = function (event) {
    callback(new Uint8Array(event.target.result));
  };
  reader.onerror = function (error) {
    console.error("Error reading file chunk:", error);
    callback(null);
  };
  const blob = file.slice(start, end);
  reader.readAsArrayBuffer(blob);
}
