// const baseUrl = 'https://yourdomainhere.com/api'; //
const baseUrl = 'http://10.0.2.2:3000/api/v1/user'; // bluestack local ip for xampp server

// const imageBaseUrl = 'https://yourdomainhere.com/';
const imageBaseUrl = 'http://10.0.2.2:3000/';

// authentication
const loginApi = "$baseUrl/login";
const registerApi = "$baseUrl/register";
const checkResetPassApi = "$baseUrl/check-reset-pass";
const resetPassApi = "$baseUrl/reset-pass";

// home
const categoriesApi = "$baseUrl/category-all";
const getPostsApi = "$baseUrl/post-all";
const createPostApi = "$baseUrl/post-create";
const editPostApi = "$baseUrl/post-edit";
const likeUnlikeApi = "$baseUrl/like-unlike/";
const deletePostApi = "$baseUrl/delete-post/";
const savePostApi = "$baseUrl/save-post/";
const removeSavePostApi = "$baseUrl/remove-saved-post/";
const deletePostPermenanetApi = "$baseUrl/delete-post-permanent/";
const deletedPostsApi = "$baseUrl/deleted-posts";
const getSavedPostApi = "$baseUrl/get-saved-posts";
