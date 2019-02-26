<template>
  <div id="app">
    <virtualList :data=data></virtualList>
  </div>
</template>

<script>
import virtualList from './pages/virtualList/virtualList.vue'
export default {
  components:{
    virtualList
  },
  name: 'App',
  data: function() {
    return {
      data:  [],
      itemHeight:40
    }
  },
  mounted(){
 
    for(let i = 0; i < 200; i++) {
      this.data.push({
        value: i,
        index: i
      })
    }
 
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
