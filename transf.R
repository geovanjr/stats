
transf <- function(x, trans, data, plot) {
  
  require(dplyr, quietly = TRUE); require(ggpubr, quietly = TRUE)
  
if (missing(data)) { 
    
    var <- x
    
  } else { 
    
    data <- data %>% as.data.frame()
    
    var <- data[,deparse(substitute(x))] }
  
  var_name <- deparse(substitute(x))
  
  sw_raw <- shapiro.test(var)
  
  qq_raw <- var %>% 
    ggqqplot() +
    labs(title = paste0(var_name, ' (raw)'), 
         subtitle = substitute(paste('Shapiro-Wilk = ', s_raw, ', p = ', p_raw), 
                               list(s_raw = round(sw_raw$statistic,3), 
                                    p_raw = round(sw_raw$p.value,3))))
  
  if (trans == 'log') {
    
    if (any(var == 0)){
      
      var <- log(var + 0.5) 
      
    } else { var <- log(var) }
    
    sw <- shapiro.test(var)
    
  }
  
  if (trans == 'log2') {
    
    if (any(var == 0)){
      
      var <- log2(var + 0.5) 
      
    } else { var <- log2(var) }
    
    sw <- shapiro.test(var)
    
  }
  
  if (trans == 'log10') {
    
    if (any(var == 0)){
      
      var <- log10(var + 0.5) 
      
    } else { var <- log10(var) }
    
    sw <- shapiro.test(var)
    
  }
  
  if (trans == 'sqrt') {
    
    if (any(var == 0)){
      
      var <- sqrt(var + 0.5) 
      
    } else { var <- sqrt(var) }
    
    sw <- shapiro.test(var)
    
  }
  
  if (trans == 'sq') {
    var <- var^2
    
    sw <- shapiro.test(var)
    
  }
  
  if (trans == 'cuberoot') {
    var <- var^(1/3)
    
    sw <- shapiro.test(var)
    
  }
  
  if (trans == 'inverse') {
    
    if (any(var == 0)){
      
      var <- 1/(var + 0.5) 
      
    } else { var <- 1/var }
    
    sw <- shapiro.test(var)
    
  }
  
  if (trans == 'zscore') {
    
    var <- (var - mean(var, na.rm = TRUE)) / sd(var)
    
    sw <- shapiro.test(var)
    
  }
  
  if (trans == 'center') {
    
    var <- var - mean(var, na.rm = TRUE)
    
    sw <- shapiro.test(var)
    
  }
  
  qq_trans <- var %>% 
    ggqqplot() +
    labs(title = paste0(var_name, ' (',trans,')'), 
         subtitle = substitute(paste('Shapiro-Wilk = ', s, ', p = ', p), 
                               list(s = round(sw$statistic,3), p = round(sw$p.value,3))))
  
  qq_grid <- ggarrange(qq_raw, qq_trans)
  
  if (missing(plot) || plot == TRUE) {
    print(qq_grid)
  }
  
  res <- list(x = var, W = sw$statistic, p = sw$p.value, plot_raw = qq_raw, plot_trans = qq_trans, plot_grid = qq_grid)
  
}
