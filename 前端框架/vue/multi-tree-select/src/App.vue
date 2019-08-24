<template>
  <div id="app">
    <MultiTreeSelect
      :init-data="jobTreeConf.initData"
      :fields='jobTreeConf.fields'
      :field-texts='jobTreeConf.fieldTexts'
      :inputContent="inputContent"
      :default-select-all="true"
      @change='change'
    ></MultiTreeSelect>
  </div>
</template>

<script>
import MultiTreeSelect from './multi-tree-select'

export default {
  name: 'App',
  components: {
    MultiTreeSelect
  },
  data() {
    return {
        inputContent:[],
        jobTreeConf: {
        initData:{
        },
         fields: ["level_1","level_2"],
        fieldTexts: ["一级","二级"]
      },
    }
  },
  mounted() {
    this.jobTreeConf.initData={
      level_1: [
        {
            key: "1_2", text: "测试一级2",
            level_2: [
                { key: "2_5", text: "测试二级5" },
                { key: "2_6", text: "测试二级6" },
                { key: "2_7", text: "测试二级7" },
                { key: "2_8", text: "测试二级8" }
            ]
        },
        {
            key: "1_3", text: "测试一级3",
            level_2: [
                { key: "2_9", text: "测试二级9" },
                { key: "2_10",text: "测试二级10" },
                { key: "2_11",text: "测试二级11" },
                { key: "2_12",text: "测试二级12" }
            ]
        }
    ]
    }
  },
  methods: {
    change(data) {
       this.setQueryJobName(data); //MultiTreeSelect组件不能使用v-model实现数据的双向绑定，只能通过change事件监听到数据的变化
    },
    setQueryJobName(data) {

      const jobClassIdAndName = this.jobTreeConf.initData.level_1.map(item => {
        return {
          id: item.key,
          name: item.text
        }
      })
      const jobMap = new Map()
      jobClassIdAndName.forEach(item => {
        jobMap.set(item.id, item.name)
      })

      const indexSelected = data.indexSelected[0];

      this.inputContent = indexSelected.map(id => {
        if(jobMap.get(id)) {
          return {
            id,
            name:jobMap.get(id)
          }
        }
      })
    },
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
