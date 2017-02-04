var http = require('http'),
    fs = require('fs');

function Spider(postId, seeLz) {
    this.currentPageNum = 1;
    this.numOfPagesToCrawl = 0;
    this.baseUrl = 'http://tieba.baidu.com/p/' 
                   + postId 
                   + '?see_lz=' 
                   + (seeLz || 1)
                   + '&pn=';
    this.data = '';
}

Spider.prototype = {
    constructor: Spider,
    
    crawl: function(pageNum) {
        var self = this;
        var url = this.baseUrl + (pageNum || this.currentPageNum);

        http.request(url, function(res){

            res.setEncoding("utf8");

            // response returns chunks
            res.on('data', function(chunk){
                this.data += chunk;
            });
            res.on('end', function(){
                var that = this;
                // because of the nature of asynchronous, can't simply return the data here, but bring in Processor object for data processing
                var processor = new Processor(this.data);
                var title = processor.getTitle();
                this.numOfPagesToCrawl = processor.getPageCount();

                console.log(title);
                console.log('====================');
                console.log('');

                var posts = processor.getPosts();

                var index = 0;
                var interval = setInterval(function() {
                    console.log(posts[index]);
                    console.log("> posts left on the current page: " + (posts.length - index));
                    console.log('~~~~~~~~~~~~~~~~~~~~');
                    processor.writeFile(title, posts[index] + '\n\n');
                    index++;
                    if (index >= posts.length) {
                        
                        console.log("end of this page");
                        
                        this.data = '';
                        self.currentPageNum++;
                        clearInterval(interval);

                        if (self.currentPageNum < that.numOfPagesToCrawl) {
                            console.log("get ready to the next page");
                            self.crawl(self.currentPageNum);
                        } else {
                            console.log("that's all there's to it...");
                        }
                    } 
                }, 500);

            });
        }).end();
    } 
};

function Processor(data) {
    this.data = data;
}

Processor.prototype = {
    constructor: Processor,
    
    // to extract page content that only exists in a single location
    matchSingle: function(regex) {
        var matched = this.data.match(regex);
        var result = !!matched? matched[1] : ''; 
        return result;
    },

    // to extract page contents that exist in multiple locations
    matchMulti: function(regex) {
        var matched = this.data.match(regex);
        var results = !!matched? matched : [];
        return results;
    },

    // to remove rubbish contents 
    purify: function(str) {
        var htmlTags = /<.*?>/g;
        var spaces = /\s+/g;
        var purified = str.replace(htmlTags, '')
                          .replace(spaces, '');
        return purified;
    },

    // to extract total page counts
    getPageCount: function() {
        var pageCount = this.matchSingle(/<li class="l_reply_num.*?<\/span>.*?<span.*?>(.*?)<\/span>/);
        return pageCount;
    },

    // to extract post title
    getTitle: function() {
        var title = this.matchSingle(/core_title_txt.*?title="(.*?)"/);
        return title;
    },

    // to extract all posts in a given page
    getPosts: function() {
        var rawPosts = this.matchMulti(/<div.id="post_content_\d.*?>(.*?)<\/div>/g);
        var posts = [];
        for (var i = 0; i < rawPosts.length; i ++) {
            posts.push(this.purify(rawPosts[i]));
        }
        return posts;
    },

    writeFile: function(fileName, data) {
        fs.appendFile((fileName || 'output') + '.txt', data, function(err) {
            if (err) {
                throw err;
            }
        })
    }
};


var spider = new Spider(process.argv[2] || 3138733512);
spider.crawl();